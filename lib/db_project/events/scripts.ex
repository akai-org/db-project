defmodule DbProject.Events.Scripts do
  @moduledoc """
  This module allow you to
  - transform CSV file from old db to new one which will be supported by the new system
  - download images from all events

  In order to get CSV file from old database, run following query:

  ```SQL
  SELECT DISTINCT
  p.id as 'id',
  p.post_title as 'title',
  p.post_content as 'content',
  p.post_name as 'slug',
  metaDate.meta_value as 'date',
  metaLocation.meta_value as 'location',
  metaRegister.meta_value as 'registration_url',
  metaFB.meta_value as 'facebook_url',
  thumbnail.id as 'thumbnail_id',
  thumbnail.guid as 'thumbnail',
  photo.id as 'photo_id',
  photo.guid as 'horizontal_photo'

  FROM
  wp_term_relationships t
  LEFT JOIN wp_posts p on t.object_id = p.id
  LEFT JOIN wp_postmeta metaDate on (t.object_id = metaDate.post_id and metaDate.meta_key = 'event_date')
  LEFT JOIN wp_postmeta metaLocation on (t.object_id = metaLocation.post_id and metaLocation.meta_key = 'location_address')
  LEFT JOIN wp_postmeta metaRegister on (t.object_id = metaRegister.post_id and metaRegister.meta_key = 'registration_url')
  LEFT JOIN wp_postmeta metaFB on (t.object_id =  metaFB.post_id and  metaFB.meta_key = 'facebook_url')
  LEFT JOIN wp_postmeta thumbnail_id on (t.object_id =  thumbnail_id.post_id and  thumbnail_id.meta_key = '_thumbnail_id')
  LEFT JOIN wp_posts thumbnail on (thumbnail_id.meta_value = thumbnail.id)
  LEFT JOIN wp_postmeta photo_id on (t.object_id =  photo_id.post_id and  photo_id.meta_key = 'horizontal_photo')
  LEFT JOIN wp_posts photo on (photo_id.meta_value = photo.id)

  WHERE
  t.term_taxonomy_id = 5;

  /* FOR SOME REASON MYSQL 5.7.20 ON MY COMPUTER COULDN'T PRODUCE VALID CSV FAIL
  HOWEVER DATAGRIP DID IT WELL
  INTO OUTFILE '/var/lib/mysql-files/events_old.csv'
  FIELDS TERMINATED BY ','
  ENCLOSED BY '"'
  LINES TERMINATED BY '\n' */;
  ```

  """

  @date_field 4
  @thumbnail_field 9
  @photo_field 11
  @fields_names [:old_id, :name, :description, :slug, :date, :location,
    :registration_url, :facebook_url, :thumbnail_id, :thumbnail_url,
    :photo_id, :photo_url
  ]

  @doc """
  Run script which will:
    - read from given CSV
    - download images to given directory
    - generate seed file
  """
  def run(file \\ "events_old.csv", images_path \\ "priv/static/images", seed_file \\ "priv/repo/seeds_events.exs") do
    events = file
    |> read_from_csv
    |> Enum.map(&process_event(&1))

    events |> Enum.each(&download_images(&1, images_path))
    events |> make_seed(seed_file)

    :ok
  end

  defp read_from_csv(file) do
    File.stream!(file) |> CSV.decode()
  end

  defp process_event(event) do
    with {:ok, event} <- event do
      event
      |> update_date_format
      |> update_images_urls
    else
      {:error, event} -> IO.inspect(event)
    end
  end

  defp update_date_format(event) do
    case Enum.fetch!(event, @date_field) |> String.length do
      0 -> event
      _ -> new_date = event
          |> Enum.fetch!(@date_field)
          |> Integer.parse
          |> elem(0)
          |> DateTime.from_unix!
          |> DateTime.to_iso8601

          List.replace_at(event, @date_field, new_date)
    end
  end

  defp update_images_urls(event) do
    new_thumbnail_url = Enum.fetch!(event, @thumbnail_field) |> update_image_url
    new_photo_url = Enum.fetch!(event, @photo_field) |> update_image_url

    event
    |> List.replace_at(@thumbnail_field, new_thumbnail_url)
    |> List.replace_at(@photo_field, new_photo_url)
  end

  defp update_image_url(""), do: ""
  defp update_image_url(url) do
    url
    |> URI.parse
    |> Map.put(:host, "akai.org.pl")
    |> Map.put(:scheme, "https")
    |> Map.put(:port, 443)
    |> URI.to_string
  end

  defp download_images(event, images_path) do
    event
    |> download_image(@thumbnail_field, images_path)
    |> download_image(@photo_field, images_path)
  end

  defp download_image(event, field, images_path) do
    event
    |> Enum.fetch!(field)
    |> download(images_path)

    event
  end

  defp download("", _images_path), do: :okx
  defp download(url, images_path) do
    with {:ok, %HTTPoison.Response{status_code: 200, body: body}} <- HTTPoison.get(url, [], [ ssl: [{:versions, [:'tlsv1.2']}] ]),
         %URI{path: path} <- URI.parse(url)
    do
      images_path = Path.expand(images_path)
      path = "#{images_path}#{path}"
      save(path, body)
    end
  end

  defp save(path, body) do
    Path.dirname(path) |> File.mkdir_p!
    File.write!(path, body)
  end

  defp make_seed(events, seed_file) do
    output = File.open!(seed_file, [:write, :utf8])
    events
    |> Enum.map(&convert_to_seed(&1))
    |> Enum.each(&IO.write(output, &1))
    :ok
  end

  defp convert_to_seed(event) do
    event = Enum.map(event, &prepare_string(&1))
    event = Enum.zip(@fields_names, event)
      |> Enum.map(fn ({field, value}) ->
        Atom.to_string(field) <> ": " <> value
      end)
      |> Enum.join(", ")

    ~s[DbProject.Repo.insert!(%DbProject.Event{#{event}})\n]
  end

  defp prepare_string(string) do
    ~s(~s|#{string}|)
  end
end
