#import "../lib.typ": plantuml

#set page(width: auto, height: auto, margin: 1cm)

#plantuml("
@startuml
Alice -> Bob: Hello
Bob --> Alice: Hi there
@enduml
", "/test/assets/test1.svg")

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
", "/test/assets/test2.svg")

#plantuml("
@startuml
listfonts
@enduml
", "/test/assets/test3.svg")