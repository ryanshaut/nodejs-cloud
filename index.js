import axios from "axios";
import express from "express";
const app = express();
const port = process.env.PORT || 1234; // default port to listen

app.get("/", (req, res) => {
    res.send("Hello world!");
});

app.get("/env", (req, res) => {
    res.send(process.env);
});

app.get("/random", async (req, res) => {
    try {
        const data = await axios.get("https://random-data-api.com/api/users/random_user");
        res.send(data.data);
    } catch (err) {
        console.log("error: ", err);
        res.send(err);
    }
});

app.get("/info", async (req, res) => {
    try {
        const data = await axios.get("https://random-data-api.com/api/users/random_user");
        res.send(data.data);
    } catch (err) {
        console.log("error: ", err);
        res.send(err);
    }
});

app.get("/error/:id", (req, res) => {
    res.statusCode = req.params.id
    res.send("error!");
});



// start the Express server
app.listen(port, () => {
    console.log(`server started at http://localhost:${port}`);
});