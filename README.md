Usage:

docker run -p 10086:8080 -v /mnt/md126/wujun/proj/test/downsample/wgs:/data --name mybrowser jbrowse:0.1

# Create - needs to be empty 
docker exec mybrowser bash -c 'cd /srv/jbrowse2/; jbrowse create .'
# Then assembly. We symlink and we allow magic from container
docker exec mybrowser samtools faidx /data/human.fa
docker exec mybrowser bash -c 'jbrowse add-assembly /data/human.fa --out /srv/jbrowse2/ --load symlink'
# Then all the different tracks with their names
docker exec mybrowser bash -c 'jbrowse add-track /data/CAP27WGS_MA006W/aln/CAP27WGS_MA006W.cons.filtered.bam --name tentacles --out /srv/jbrowse2/ --load symlink'
# Index names and so
docker exec mybrowser bash -c 'jbrowse text-index --out /srv/jbrowse2/'
