const express = require('express');
const bodyParser = require('body-parser');

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
