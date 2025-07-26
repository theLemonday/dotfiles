let
  pubKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILdlEObI93etlD0rhez2geqcZYPq9eIaSzLYt1Tlwigm agenix";
in
{
  "anki_username.age".publicKeys = [ pubKey ];
  "anki_password.age".publicKeys = [ pubKey ];
}
