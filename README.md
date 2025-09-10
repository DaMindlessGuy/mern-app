# This has been grabbed from the original source [here](https://github.com/doananhtingithub40102/mern-app) and we will be working off of this

# How to contribute via github
1. You need to have created a github account and tell the project maintainer (Patrick) what your GitHub username is so I can add you as a contributer
2. You want to add your public SSH key to your GitHub account so you can push code. 
3. You do this by first going to `https://github.com` and then logging in. 
4. Click on your icon on the top right and then going to `Settings`
5. Under `Access` click on `SSH and GPG keys`
6. Click on `New SSH key` and give an appropriate name, such as `my AWS EC2 SSH key`
7. Go to the terminal and type in `cat ~/.ssh/id_rsa.pub` and copy the output of that into `Key` then click on `Add SSH Key`
8. Now you can go back to your terminal and clone the source code to be able to work on it by using `git clone $REPO_LOCATIONS && cd mern-app`
9. After making your contributions type in `git add .` `git commit -m Type in your message here` `git push`
# Basic MERN App

![my picture](https://doananhtingithub40102.github.io/MyData/mern/mypicture.png)

A full-stack [MERN](https://www.mongodb.com/mern-stack) application for managing information of employees.

## About the project

This is a full-stack MERN application that manages the basic information of employees. The app uses an employee database from the MongoDB Atlas database and then display it using a React.

## Tech Stack

**Client:** React, Bootstrap

**Server:** NodeJS, ExpressJS

**Database:** MongoDB

## Run Locally

Clone the project

```bash
  git clone https://github.com/doananhtingithub40102/mern-app.git
```

Go to the project directory

```bash
  cd mern-app
```

Create an Atlas URI connection parameter in `server/.env` with your Atlas URI:
```
ATLAS_URI="mongodb+srv://<username>:<password>@cluster0.6cgz2s1.mongodb.net/?retryWrites=true&w=majority"
PORT=5000
```

Create an hostname on server enviroment variable in `client/.env` with your hostname on server:
```
REACT_APP_YOUR_HOSTNAME="http://localhost:5000"
```

Install dependencies

```bash
  cd server
  npm install
```

```bash
  cd client
  npm install
```

Start the server

```bash
  cd server
  node server.js
```
Start the Client

```bash
  cd client
  npm start
```
  

## Features in the project

- The user can **create** the information of a employee, and managing it.

- **Displaying** the information of employees, including the name, position, and level of the employee.

- Includes **Update** and **Delete** actions.

## Learn More

**FrontEnd**

* To learn React, check out the [React documentation](https://reactjs.org/).

* You can learn more in the [Create React App documentation](https://facebook.github.io/create-react-app/docs/getting-started).

* Get started with [Bootstrap](https://www.w3schools.com/bootstrap5/index.php), the world's most popular framework for building responsive, mobile-first websites.

**BackEnd**

* [Node.js Tutorial](https://www.w3schools.com/nodejs/default.asp)

* [ExpressJS Tutorial](https://www.tutorialspoint.com/expressjs/index.htm)

**Database**

* [MongoDB Tutorial](https://www.w3schools.com/mongodb/)

* Follow the [Get Started with MongoDB Atlas](https://www.mongodb.com/docs/atlas/getting-started/) guide to create an Atlas cluter, connecting to it, and loading your data.

**Fullstack**

* Learn all about the [MERN stack](https://www.mongodb.com/languages/mern-stack-tutorial) in this step-by-step guide on how to use it by developing a simple CRUD application from scratch.

## Live app

<a href="https://employee-manager-tindoan-xu3i.onrender.com/">Live fullstack MERN app</a>
