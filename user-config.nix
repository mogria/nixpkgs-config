let 
  config = rec {
    name = "Mogria";
    username = "mogria";
    git = rec {
      email = "m0gr14@gmail.com";
      signingKey = null;
    };
    github = rec {
      inherit username;
      baseLink = {
        http = "https://github.com/${username}";
        ssh = "git@github.com:${username}";
      };
      repositoryNames = [ "home-manager" "guezzlpage" ];
      repos = builtins.listToAttrs (map (type: {
        name = type;
        value = map (repo: getGithubRepo type repo) repositoryNames;
      }) (builtins.attrNames baseLink));
    };
    getGithubRepo = type: reponame: "${builtins.getAttr type github.baseLink}/${reponame}";
    directories = {
      home = builtins.getEnv "HOME";
      code = "Code";
      documents = "Documents";
    };
    homemanager = {
      development = true;
      repo = type: getGithubRepo type "home-manager";
    };
  };
in config // {
  getDirectory = directoryName: "${config.directories.home}/${builtins.getAttr directoryName config.directories}";
  }
