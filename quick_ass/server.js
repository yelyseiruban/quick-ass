const express = require('express');
const bodyParser = require('body-parser');
const WebSocket = require('ws');
const { performance } = require('perf_hooks');  // This helps emulate timestamp for mock data

const wss = new WebSocket.Server({ port: 8080 });


const app = express();
const port = 3000;

// Use body-parser to parse JSON bodies
app.use(bodyParser.json());

// In-memory array to hold data
let dataStorage = [];

// Endpoint to get all data
app.get('/data', (req, res) => {
    res.json(dataStorage);
});

// Endpoint to add new data
app.post('/data', (req, res) => {
    const { address, lat, lng } = req.body;

    // Create new data record
    const newRecord = {
        address: address,
        created_at: new Date().toISOString(), // Current date and time
        lat: parseFloat(lat), // Ensure lat is a number
        lng: parseFloat(lng)  // Ensure lng is a number
    };

    // Add new record to the dataStorage array
    dataStorage.push(newRecord);

    res.status(201).json({
        message: 'Record added successfully',
        data: newRecord
    });
});

// Start the server
app.listen(port, () => {
    console.log(`Server is running on http://localhost:${port}`);
});

function getDistance(lat1, lon1, lat2, lon2) {
    const R = 6378137; // Earth's radius in meters
    const toRadians = degrees => degrees * Math.PI / 180;

    const dLat = toRadians(lat2 - lat1);
    const dLon = toRadians(lon2 - lon1);

    const a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
        Math.cos(toRadians(lat1)) * Math.cos(toRadians(lat2)) *
        Math.sin(dLon / 2) * Math.sin(dLon / 2);

    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));

    return R * c;
}

wss.on('connection', ws => {
    ws.on('message', message => {
        try {
            const data = JSON.parse(message);
            const { lat, lon } = data;

            // Filter out old devices and find the closest device
            const thresholdSeconds = 15;
            const now = performance.now();

            const recentDevices = activeDevices.filter(device => {
                return (now - device.createdAt) / 1000 <= thresholdSeconds;
            });

            let closestDevice = null;
            let smallestDistance = Infinity;

            recentDevices.forEach(device => {
                const distance = getDistance(lat, lon, device.lat, device.lon);
                if (distance < smallestDistance) {
                    smallestDistance = distance;
                    closestDevice = device;
                }
            });

            if (closestDevice) {
                ws.send(JSON.stringify({ closestDevice, distance: smallestDistance }));
            } else {
                ws.send(JSON.stringify({ error: 'No recent devices found within 15 seconds.' }));
            }
        } catch (error) {
            ws.send(JSON.stringify({ error: 'Invalid message format' }));
        }
    });

});

console.log('WebSocket server running on ws://localhost:8080');


// Simulates adding a new device every 5-10 seconds for testing
setInterval(() => {
    const newDevice = {
        lat: 51.0 + (Math.random() - 0.5) * 0.01,  // Random latitude around 51.0
        lon: 0.0 + (Math.random() - 0.5) * 0.01,   // Random longitude around 0.0
        createdAt: performance.now(),
    };
    activeDevices.push(newDevice);
    console.log(activeDevices);

    // Clear out devices older than 30 seconds (for example)
    const cutoffTime = performance.now() - 30000;
    activeDevices = activeDevices.filter(device => device.createdAt > cutoffTime);
}, 5000); // Adjust interval as needed for simulation