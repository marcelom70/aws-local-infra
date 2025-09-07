.PHONY: start stop restart deploy clean

start:
	docker-compose up -d

stop:
	docker-compose down

restart: stop start

deploy:
	./deploy-all.sh

clean:
	docker-compose down -v
	rm -f functions/function.zip
	rm -f minha-key.pem

status:
	curl -s http://localhost:4566/health | jq .