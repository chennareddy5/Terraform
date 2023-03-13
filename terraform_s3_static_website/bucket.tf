resource "aws_s3_bucket" "mywebsite" {
  bucket = "fruitkart.com"
  acl    = "public-read"
  policy = file("policy.json")
  website {
    index_document = "index.html"
    error_document = "error.html"
  }
  tags = {
    Name        = "My website Bucket"
    Environment = "Terraform"
  }
}

resource "aws_s3_bucket_object" "index" {
  bucket       = aws_s3_bucket.mywebsite.id
  acl          = "public-read" # or can be “public-read”
  key          = "index.html"
  source       = "./index.html"
  etag         = filemd5("./index.html")
  content_type = "text/html"
}


resource "aws_s3_bucket_object" "error" {
  bucket = aws_s3_bucket.mywebsite.id
  acl    = "public-read"
  # or can be “public-read”
  key          = "error.html"
  source       = "./error.html"
  etag         = filemd5("./error.html")
  content_type = "text/html"
}
