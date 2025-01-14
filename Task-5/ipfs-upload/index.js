const axios = require('axios');
const FormData = require('form-data');
const fs = require('fs');
require('dotenv').config();

const PINATA_API_KEY = process.env.PINATA_API_KEY;
const PINATA_SECRET_KEY = process.env.PINATA_SECRET_KEY;

const PINATA_BASE_URL = process.env.PINATA_BASE_URL;

async function uploadImageToPinata(imagePath, fileName) {
    try {
        
        if (!fs.existsSync(imagePath)) {
            throw new Error('Image file not found');
        }

        const formData = new FormData();
        const fileStream = fs.createReadStream(imagePath);
        
        formData.append('file', fileStream, {
            filename: fileName
        });

        const metadata = JSON.stringify({
            name: fileName,
            keyvalues: {
                uploadDate: new Date().toISOString()
            }
        });
        formData.append('pinataMetadata', metadata);

        const pinataOptions = JSON.stringify({
            cidVersion: 1,
            wrapWithDirectory: false
        });
        formData.append('pinataOptions', pinataOptions);

        const response = await axios.post(
            `${PINATA_BASE_URL}${PINATA_ENDPOINT}`,
            formData,
            {
                headers: {
                    'Content-Type': `multipart/form-data; boundary=${formData._boundary}`,
                    'pinata_api_key': PINATA_API_KEY,
                    'pinata_secret_api_key': PINATA_SECRET_KEY
                }
            }
        );

        return response.data;
    } catch (error) {
        console.error('Error uploading to Pinata:', error);
        throw error;
    }
}

async function main() {
    try {
        const result = await uploadImageToPinata(
            './image.png',
            'image.png'
        );
        
        console.log('Upload successful!');
        console.log('IPFS Hash:', result.IpfsHash);
        console.log('Pin Size:', result.PinSize);
        console.log('Timestamp:', result.Timestamp);
        
        console.log('\nAccess your image at:');
        console.log(`https://ipfs.io/ipfs/${result.IpfsHash}`);
    } catch (error) {
        console.error('Upload failed:', error.message);
    }
}