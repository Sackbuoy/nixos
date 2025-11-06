{
  programs.mise = {
    enable = true;
    globalConfig = {
      env = {
        GITLAB_ORG = "gitlab.com/realm-security";
        GOPRIVATE = "{{env.GITLAB_ORG}}";
        GOTESTSUM_FORMAT = "pkgname-and-test-fails";
        GOTESTSUM_FORMAT_ICONS = "hivis";
        AWS_PROFILE = "dev";
      };
      tools = {
        go = "1.25.3";
        golangci-lint = "2.5.0";
        usage = "latest";
      };
      tasks = {
        "aws:dev:ecr-login" = {
          env = {
            AWS_PROFILE = "dev";
            ACCOUNT_ID = "891377291630";
            AWS_REGION = "us-east-2";
          };
          run = "aws ecr get-login-password | docker login --username AWS --password-stdin \${ACCOUNT_ID}.dkr.ecr.\${AWS_REGION}.amazonaws.com";
        };
        localstack = {
          run = "localstack start --docker --no-banner --detached";
        };
      };
      settings = {
        experimental = true;
        cargo_binstall = true;
      };
    };
  };
}
