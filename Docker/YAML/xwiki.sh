echo xwiki | docker secret create xwiki-db-username -
echo $(openssl rand -base64 32|tr -d '+=/'|fold -w 16|head -1)|docker secret create xwiki-db-password -
echo $(openssl rand -base64 32|tr -d '+=/'|fold -w 16|head -1)|docker secret create xwiki-db-root-password -
docker stack deploy --compose-file xwiki.yml xwiki
