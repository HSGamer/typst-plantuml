#import "../lib.typ": plantuml

#set page(width: auto, height: auto, margin: 1cm)

#plantuml("
@startuml
Alice -> Bob: Hello
Bob --> Alice: Hi there
@enduml
")

#plantuml("
@startuml
participant Client
participant Server
participant Database

Client -> Server: Request
Server -> Database: Query
Database --> Server: Results
Server --> Client: Response
@enduml
")

#plantuml("
@startuml
listfonts
@enduml
")