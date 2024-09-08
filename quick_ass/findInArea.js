const distance = 1;
function areLocationsClose(location1, location2, threshold = 4014) {
    // Earth's radius in meters
    const R = 6378137;

    // Convert degrees to radians
    const toRadians = (degrees) => degrees * Math.PI / 180;

    // Calculate the offsets in meters
    const dn = (location2.lat - location1.lat) * R;
    const de = (location2.lng - location1.lng) * (R * Math.cos(toRadians(location1.lat)));

    // Calculate the distance between the two points
    const distance = Math.sqrt(dn * dn + de * de);
    console.log(distance)

    // Return true if the distance is less than or equal to the threshold
    return distance <= threshold;
}

// Example usage:
const location1 = { lat: 51.0, lng: 0.0 };
const location2 = { lat: 51.0, lng: 0.001 }; // Change this value to test

const areClose = areLocationsClose(
    location1, location2
);

console.log(`Are the locations within ${distance} meters?`, areClose);
