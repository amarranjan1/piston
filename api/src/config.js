const fs = require('fs');
const Logger = require('logplease');
const logger = Logger.create('config');

function parseIntSafe(value) {
    const parsed = parseInt(value, 10);
    return isNaN(parsed) ? null : parsed;
}

const options = {
    log_level: {
        desc: 'Level of data to log',
        default: 'INFO',
        validators: [
            x => Object.keys(Logger.LogLevels).includes(x.toUpperCase()) || `Log level ${x} does not exist`,
        ],
    },
    bind_address: {
        desc: 'Address to bind REST API on',
        default: `0.0.0.0:${process.env['PORT'] || 2000}`,
        validators: [],
    },
    data_directory: {
        desc: 'Absolute path to store all piston related data at',
        default: '/piston',
        validators: [
            x => fs.existsSync(x) || `Directory ${x} does not exist`,
        ],
    },
    runner_uid_min: {
        desc: 'Minimum uid to use for runner',
        default: 1001,
        parser: parseIntSafe,
        validators: [x => x !== null || `Value is not a number`],
    },
    runner_uid_max: {
        desc: 'Maximum uid to use for runner',
        default: 1500,
        parser: parseIntSafe,
        validators: [x => x !== null || `Value is not a number`],
    },
    disable_networking: {
        desc: 'Set to true to disable networking',
        default: true,
        parser: x => x === 'true',
        validators: [x => typeof x === 'boolean' || `${x} is not a boolean`],
    },
};

Object.freeze(options);

function applyValidators(validators, value) {
    for (const validator of validators) {
        const response = validator(value);
        if (response !== true) return response;
    }
    return true;
}

logger.info(`Loading Configuration from environment`);

let config = {};

for (const key in options) {
    const envKey = `PISTON_${key.toUpperCase()}`;
    const option = options[key];
    const parser = option.parser || (x => x);
    const envValue = process.env[envKey];
    const parsedValue = parser(envValue);
    const finalValue = envValue === undefined ? option.default : parsedValue;
    const validationResponse = applyValidators(option.validators, finalValue);

    if (validationResponse !== true) {
        logger.error(`Config option ${key} failed validation:`, validationResponse);
        process.exit(1);
    }
    config[key] = finalValue;
}

logger.info('Configuration successfully loaded');

module.exports = config;
