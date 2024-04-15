//////////////////////////////////////////////////
// Author: Krishnan Navadia                     //
// This is the source code for this challenge!  //
//////////////////////////////////////////////////

const express = require("express");
const mongoose = require("mongoose");
const bcrypt = require("bcrypt");
const expressValidator = require("express-validator");
const session = require("express-session");
require("dotenv").config();

const app = express();

mongoose.connect(process.env.MONGO_URI, {
  useNewUrlParser: true,
  useUnifiedTopology: true,
});

const userSchema = new mongoose.Schema({
  username: { type: String, unique: true },
  password: String,
});

const User = mongoose.model("User", userSchema);

app.use(
  session({
    secret: process.env.SECRET,
    resave: false,
    saveUninitialized: false,
  })
);

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.use(expressValidator());

app.get("/", async (req, res) => {
  res.sendFile(__dirname + "/app.js");
});

// Registration route
app.post("/register", async (req, res) => {
  console.log("/register");
  let { username, password } = req.body;

  // Validate user input
  req.checkBody("username", "Invalid username").notEmpty();
  req.checkBody("password", "Invalid password").notEmpty();

  const errors = req.validationErrors();

  if (errors) {
    return res.status(400).json({ errors });
  }
  username = username.toLowerCase();

  if (username === "ram") {
    return res.status(400).json({ error: "using my tricks against me, huh?" });
  }

  const user = await User.findOne({ username });
  if (user) {
    return res.status(400).json({ error: "user already exists" });
  }

  try {
    // Hash the password
    const hashedPassword = await bcrypt.hash(password, 10);

    // Create a new user
    const newUser = new User({ username, password: hashedPassword });

    const data = await newUser.save();
    res.status(201).json({ message: "Registration successful" });
  } catch {
    res.status(201).json({ message: "Something went wrong" });
  }
});

// Login route
app.post("/login", async (req, res) => {
  console.log("/login");
  let { username, password } = req.body;

  // Validate user input
  req.checkBody("username", "Invalid username").notEmpty();
  req.checkBody("password", "Invalid password").notEmpty();

  const errors = req.validationErrors();

  if (errors) {
    return res.status(400).json({ errors });
  }

  username = username.toLowerCase();
  if (username === "ram") {
    return res.status(400).json({ error: "using my tricks against me, huh?" });
  }

  // Find the user by their username
  const user = await User.findOne({ username });
  if (!user) {
    return res.status(401).json({ error: "Invalid credentials" });
  }

  // Compare the provided password with the stored hash
  bcrypt.compare(password, user.password, (bcryptErr, isMatch) => {
    if (bcryptErr) {
      return res.status(500).json({ error: "Internal server error" });
    }

    if (!isMatch) {
      return res.status(401).json({ error: "Invalid credentials" });
    }

    // Store user session data (e.g., user ID) for subsequent requests
    req.session.userId = user._id;
    req.session.username = user.username;

    res.json({
      message:
        "Login successful, to get user info, go to /profile/<your_username>",
    });
  });
});

// Logout route
app.get("/logout", (req, res) => {
  console.log("/logout");
  req.session.destroy();
  res.json({ message: "Logged out" });
});

// Protected route example
app.get("/profile/:profile", (req, res) => {
  req.params.profile = req.params.profile.toLowerCase();
  console.log(req.session.username, req.params.profile);
  if (!req.session.userId) {
    return res.status(403).json({ error: "Unauthorized" });
  } else if (req.params.profile === "ram") {
    return res.status(200).send(process.env.FLAG);
  } else if (req.session.username !== req.params.profile) {
    return res.status(401).json({ error: "haha, trying to be smart?" });
  }

  // Fetch user data from MongoDB or perform other actions
  res.json({
    message: "Oh, did you missed anything?",
    user: req.session.userId,
  });
});

// Start the server
app.listen(4999, () => {
  console.log("Server is running on port 4999");
});
