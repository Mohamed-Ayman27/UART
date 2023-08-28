# UART Rx-Tx Project using Verilog

This repository contains a Verilog implementation of a UART (Universal Asynchronous Receiver-Transmitter) communication system. The project includes modules for both the Transmitter (Tx) and Receiver (Rx) components of UART communication.

## Table of Contents

- [Introduction](#introduction)
- [Modules](#modules)
  - [Transmitter (Tx)](#transmitter-tx)
  - [Receiver (Rx)](#receiver-rx)


## Introduction

UART (Universal Asynchronous Receiver-Transmitter) is a widely used serial communication protocol that allows communication between devices over a single data line. This project aims to implement the Tx and Rx components of a UART communication system in Verilog.

## Modules

### Transmitter (Tx)

The Transmitter module is responsible for converting parallel data into a serial bit stream with proper synchronization and control signals. It includes the following sub-modules:

- **Parity Generator**: Generates a parity bit for error detection.
- **Serializer**: Converts parallel data into a serial bit stream.
- **Finite State Machine (FSM) Control**: Manages the control signals for synchronization and data transmission.
- **Multiplexer (MUX)**: Selects between data and control signals to create the serial output.

### Receiver (Rx)

The Receiver module is responsible for converting the received serial bit stream back into parallel data and performing necessary checks. It includes the following sub-modules:

- **Parity Check**: Checks the parity bit for error detection.
- **Start Bit Check**: Detects the start of a data frame.
- **Stop Bit Check**: Verifies the stop bit to mark the end of a data frame.
- **De-serializer**: Converts the serial bit stream into parallel data.
- **Finite State Machine (FSM) Control**: Manages the control signals for synchronization and data reception.
- **Edge Bit Counter**: Counts bits for proper data sampling.
- **Data Sampler**: Samples the received data bits at the right time.

