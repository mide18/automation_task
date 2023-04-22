const express = require("express")
const app = express()

app.get("/", (req,res)=> {
    res.send("Hello World! Automate provisioning and deployment with github-action on port 8080")
})

// to debug if the app is running
app.listen(8080, ()=>
console.log("Hello World!")
)