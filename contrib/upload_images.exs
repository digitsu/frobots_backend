defmodule UploadImages do

  @doc ~S"""
   Uploads images from a local folder to S3.

   This function fetches list of images from respective folders and uploads to s3 under "images" folder

   #folder s3 shoud have the following sub folders equipment, protobots, frobots

   # Start the script
   #iex>UploadImages.upload_to_s3("/Users/jdoe/Desktop/s3")

   When script is done, run this command to see the list of images under equipment
   #iex>ExAws.S3.list_objects_v2("add-bucket-name",  prefix: "images/equipment") |> ExAws.request

 """
 def upload_to_s3(uploads_path) do
   # get bucket
   s3_bucket = Application.get_env(:ex_aws, :s3)[:bucket]
   #**** uploads_path must exists ****
   equipment_images = File.ls!(Path.join(uploads_path, "equipment"))
   frobots_images =  File.ls!(Path.join(uploads_path, "frobots"))
   protobots_images = File.ls!(Path.join(uploads_path, "protobots"))
   avatar_images = File.ls!(Path.join(uploads_path, "avatars"))

   upload_files(s3_bucket, "equipment", equipment_images,  uploads_path )
   upload_files(s3_bucket, "frobots", frobots_images, uploads_path)
   upload_files(s3_bucket, "protobots", protobots_images,  uploads_path)
   upload_files(s3_bucket, "avatars", avatar_images,  uploads_path)

   {:ok, "success"}
 end

 def upload_files(bucket, prefix, file_list,  upload_file_path) do
   file_list
   |> Enum.map(fn file_name ->
     "#{upload_file_path}/#{prefix}/#{file_name}"
     |> ExAws.S3.Upload.stream_file()
     |> ExAws.S3.upload(bucket, "/images/#{prefix}/#{file_name}", acl: :public_read)
     |> ExAws.request()
   end)
 end
end
