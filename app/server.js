const express = require("express");

const app = express();
const PORT = process.env.PORT || 3000;

app.get("/", (req, res) => {
  res.json({
    message: "DevOps Full Stack Project is running",
    version: "1.0.0"
  });
});

app.get("/health", (req, res) => {
  res.status(200).json({
    status: "healthy"
  });
});

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});