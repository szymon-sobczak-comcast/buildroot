#!/bin/node

const greeter = require('./src/greeter')

console.log(greeter.greet(process.argv[2]))
