{
  config,
  pkgs,
  username,
  ...
}: {
  services.cloudflared.tunnels."879b9366-b8d1-4cdb-9ae7-4a4aa483d0f2" = {
    credentialsFile = "/home/${username}/.cloudflared/cert.pem";
    default = "http_status:404";
  };
}