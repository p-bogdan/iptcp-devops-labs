docker build -t practicalcloud/haystack .

docker save practicalcloud/haystack > ../haystack-image.tar 

# To load
# docker load -i haystack-image.tar
