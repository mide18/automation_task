const express = require("express")
const app = express()

app.get("/", (req,res)=> {
    res.send("Hello World! This is used with a GitAction deployment")
})

// to debug if the app is running
app.listen(8080, ()=>
console.log("Hello World!")
)