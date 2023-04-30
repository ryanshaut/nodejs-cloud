import axios from "axios";
import express from "express";
const app = express();
const port = process.env.PORT || 1234; // default port to listen

app.use((req, res, next) => {
    res.append('Content-Type', 'application/json');
    res.append('X-Server', process.env.hostname || process.env.computername);
    next()
})

app.get("/", (req, res) => {
    res.send({ message: "Hello world!" });
});
app.get("/ip", (req, res) => {
    res.send({ ip: req.ip });
});

app.get("/region", (req, res) => {
    res.send({ message: process.env.AzRegion || 'unknown' });
});


app.get("/ping", (req, res) => {
    res.send(JSON.stringify(req.headers));
});

app.get("/env", (req, res) => {
    res.send({ env: process.env });
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
app.get("/magic", async (req, res) => {
    try {
        const data = await axios.get("http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https://management.azure.com/", {
            headers: {
                Metadata: 'true'
            }
        });
        res.send(data.data);
    } catch (err) {
        console.log("error: ", err);
        res.send(err);
    }
});
app.get("/magic2", async (req, res) => {

    url = req.params.url
    try {
        const data = await axios.get("http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https://management.azure.com/", {
            headers: {
                Metadata: 'true'
            }
        });
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

app.get("/healthz", (req, res) => {
    res.send("ok");
});


// start the Express server
app.listen(port, () => {
    console.log(`server started at http://localhost:${port}`);
});