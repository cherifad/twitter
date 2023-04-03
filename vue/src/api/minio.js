import axios from "axios";

const MINIO_ENDPOINT = 'http://localhost:9000'
const MINIO_ACCESS_KEY = 'your-access-key'
const MINIO_SECRET_KEY = 'your-secret-key'

const filePath = '/path/to/your/file'
const bucketName = 'your-bucket-name'
const objectName = 'your-object-name'

const url = `${MINIO_ENDPOINT}/${bucketName}/${objectName}`
const headers = {
  'Content-Type': 'application/octet-stream',
  'x-amz-acl': 'public-read',
  'x-amz-storage-class': 'STANDARD',
  'Authorization': `AWS ${MINIO_ACCESS_KEY}:${MINIO_SECRET_KEY}`
}
