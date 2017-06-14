IMAGE = $(shell basename `pwd`)

build:
	@docker build -t $(IMAGE) .

run:
	@docker run -p 5901:5901 -d  $(IMAGE)  | tee .container
	@$(MAKE) logs

logs:
	docker logs -f $$(cat .container)

stop:
	docker stop $$(cat .container)

kill:
	docker kill $$(cat .container)