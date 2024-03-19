// Datei: pages/api/log.js

export default function handler(req, res) {
    // Hier können Sie Ihre Logik implementieren, um die Daten an Grafana zu senden.
    // Zum Beispiel:
    // grafana.log(req.body);
    res.status(200).json({ message: 'Logged to Grafana' });
  }