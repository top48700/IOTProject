const express = require('express');
const Influx = require('influx');
const cors = require('cors'); // Enable CORS for cross-origin requests
const bodyParser = require('body-parser');

const app = express();
app.use(bodyParser.json());
app.use(cors()); // Enable CORS

// InfluxDB configuration
const influx = new Influx.InfluxDB({
  host: 'hciox4.ait.co.th',
  port: 59004,
  database: 'iox2024',
  username: 'admin',
  password: 'dtSDD@a1t2025',
});

// API to fetch data from InfluxDB
app.get('/data', async (req, res) => {
  try {
    console.log('Fetching data from InfluxDB...');
    const results = await influx.query(`
      SELECT * FROM PowerSensorValue LIMIT 10
    `);

    if (results.length === 0) {
      console.log('No data found in InfluxDB.');
      return res.json([]); // Return empty array if no data is found
    }

    console.log('Query Results:', results); // Debugging logs
    res.json(results); // Send results as JSON
  } catch (err) {
    console.error('Error querying InfluxDB:', err.message);
    res.status(500).json({ error: err.message });
  }
});

// Start server on all network interfaces
const PORT = 3000;
app.listen(PORT, '0.0.0.0', () => {
  console.log(`Middleware running on port ${PORT}`);
});
