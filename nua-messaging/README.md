# README
## Some architecture improvements I would suggest if it was commercial project:
1. The models can be revorked, I would use STI for user models, instead of 3 fields to get user type, 1 get used

2. Separate Inbox and Outbox tables seem redundant, messages can store sender and reciever ids, there is no need for intermediate tables
