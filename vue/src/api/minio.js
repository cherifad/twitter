//import * as Minio from "minio";

// const minioClient = new Minio.Client({
//   url: "http://127.0.0.1:9001",
//   accessKey: "76bVAD7wjaZw1UZH",
//   secretKey: "2kbNgm9ZzQIxDGkZ2UHMuMcgET1TRzAM",
//   api: "s3v4",
//   path: "auto",
// });

async function uploadFile(file) {
  // const metadata = { "Content-Type": file.type };
  // const bucketName = "your-bucket-name";
  // const objectName = file.name;
  // const stream = file.stream();

  // await minioClient.putObject(bucketName, objectName, stream, metadata);
}

export { uploadFile };
