module Domain.QRID exposing (generate)


import UUID exposing (UUID)


generate : UUID
generate = UUID.forName "myap" UUID.dnsNamespace
