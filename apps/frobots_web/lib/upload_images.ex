defmodule FrobotsWeb.UploadImages do
  def upload_to_s3() do
    # get bucket
    s3_bucket = Application.get_env(:ex_aws, :s3)[:bucket]
    chassis_img_path = Path.absname("priv/upload_to_s3/chassis")
    frobots_img_path = Path.absname("priv/upload_to_s3/frobots")
    protobots_img_path = Path.absname("priv/upload_to_s3/protobots")

    chassis_images = chassis_img_path |> File.ls!()
    frobots_images = frobots_img_path |> File.ls!()
    protobots_images = protobots_img_path |> File.ls!()

    upload_files(s3_bucket, "chassis", chassis_images, chassis_img_path)
    upload_files(s3_bucket, "frobots", frobots_images, frobots_img_path)
    upload_files(s3_bucket, "protobots", protobots_images, protobots_img_path)

    {:ok, "success"}
  end

  def upload_files(bucket, prefix, file_list, file_base_path) do
    file_list
    |> Enum.map(fn file_name ->
      "#{file_base_path}/#{file_name}"
      |> ExAws.S3.Upload.stream_file()
      |> ExAws.S3.upload(bucket, "/#{prefix}/#{file_name}", acl: :public_read)
      |> ExAws.request()
    end)
  end
end
