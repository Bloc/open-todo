# README

---

###To create a new user:

```bash
$ curl -X POST -F "user[username]=username" -F "user[password]=password" -F "user[password_confirmation]=password" http://localhost:3000/api/users
```
