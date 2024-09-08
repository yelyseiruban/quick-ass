const WebSocket = require('ws');
const { performance } = require('perf_hooks');  // This helps emulate timestamp for mock data

const wss = new WebSocket.Server({ port: 8080 });

let activeDevices = [];

// Function to calculate distance between two lat-lng pairs (Haversine formula)
