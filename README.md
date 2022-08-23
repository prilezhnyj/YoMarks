# YoMarks
### Hello. This is «YoTasks». I'll let you always stay on the work wave and not forget anything!
---
### The main tasks and functions of the application:
* Adding new tasks
* Editing current tasks
* Deleting tasks
* Accounting for tasks
---
### I used Firebase in writing the application and the following components:
* Firebase Authentication
* Firebase Firestore
* Firebase Storage
---
###  New user registration code:
```swift
    func saveUser(email: String, uid: String, completion: @escaping (Result<UsersModel, Error>) -> Void) {
        let userModel = UsersModel(email: email, uid: uid)
        usersRef.document(userModel.uid).setData(userModel.representation) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(userModel))
            }
        }
    }
```
---
### The code for saving a note to the database:
```swift
    func addData(user: User, title: String, description: String, completion: @escaping (Result<TaskModel, Error>) -> Void) {
        let taskModel = TaskModel(title: title, description: description, id: UUID().uuidString)
        usersRef.document(user.uid).collection("tasks").document(taskModel.id).setData(taskModel.representation) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(taskModel))
            }
        }
    }
```
---
[TELEGRAM](https://t.me/prilezhnyj) | [INSTAGRAM](https://instagram.com/prilezhnyj) | [EMAIL](dev.botalov@gmail.com)

---
[](https://github.com/prilezhnyj/YoMarks/blob/main/YoMarks/Resources/Assets.xcassets/Screenshot/Auth.imageset/Simulator%20Screen%20Shot%20-%20iPhone%2013%20-%202022-08-23%20at%2017.12.53.png)

