# Garmin Garmin BitWare Wallet

### This is try to make garmin hardware wallet like ledger or trezor.


## Setup
All you'll need to get started is edit the ```properties.mk``` file. Here's a description of the variables:

## Targets
- **build** - compiles the app
- **buildall** - compiles the app separately for every device in the SUPPORTED_DEVICES_LIST, packaging appropriate resources. Make sure to have your resource folders named correctly (e.g. /resources-fenix3_hr)
- **run** - compiles and starts the simulator
- **deploy** - if your device is connected via USB, compile and deploy the app to the device
- **package** - create an .iq file for app store submission

## How to use?
To execute the **run** target, run ```make run``` from the home folder of your app