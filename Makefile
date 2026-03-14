DOCKER_IMAGE = public.ecr.aws/sam/build-ruby3.3:latest-x86_64
BUILD_DIR = /tmp/retirement-lambda-build

build-RetirementFunction:
	rm -rf $(BUILD_DIR)
	mkdir -p $(BUILD_DIR)
	cp -r Gemfile Gemfile.lock lib config.ru config.rb app.rb retirement.gemspec REVISION $(BUILD_DIR)/ 2>/dev/null || true
	docker run --rm --platform linux/amd64 \
		-v $(BUILD_DIR):/var/task -w /var/task $(DOCKER_IMAGE) \
		bash -c "bundle config set --local path vendor/bundle && \
		         bundle config set --local without 'development test' && \
		         bundle install --quiet"
	@printf -- "---\nBUNDLE_PATH: \"vendor/bundle\"\nBUNDLE_WITHOUT: \"development:test\"\n" > $(BUILD_DIR)/.bundle/config
	cp -r $(BUILD_DIR)/* $(BUILD_DIR)/.bundle $(ARTIFACTS_DIR)/
