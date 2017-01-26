# Event Management System

This is the test assignment application

## Getting started

To get started with the app, clone the repo and then install the needed gems:

```
$ bundle install --without production
```

Next, migrate the database:

```
$ rails db:migrate
```

Finally, run the test suite to verify that everything is working correctly:

```
$ rails test
```

If the test suite passes, you'll be ready to run the app in a local server:

```
$ rails server
```

**EMS-API**
----
  <_App is able to sign up user, sign in and sign out. User is able to create, update, and delete events and attach file to them. Also there is an ability to create comments and invite other users to event. _>

* **Method:**

  <_The request type_>

  `GET` | `POST` | `DELETE` | `PUT` | `PATCH`

*  **URL Params**

   <_As to have an access to all the resources of app (except registration and sign in) you must to add auth_token, which is provided after registration or sign in. As for optional parameters for index action of event, you can use interval as to filter events by date, the value is integer and means count of days form current time._>

   **Required:**

   `auth_token=[string]`

   **Optional:**

   `interval=[integer]`

* **Data Params**

  <_If you use post request you should warp all the needed parameters by resource's name ._>

* **Success Response:**

  <_For example, as successful response you'll get request 200, see below!_>

  * **Code:** 200 <br />
    **Content:** `{
                    "id": 4,
                    "name": "Some fantastic event",
                    "time": "2017-01-28T17:18:51.367Z",
                    "place": "Some place",
                    "purpose": "Some purpose",
                    "created_at": "2017-01-26T15:41:15.858Z",
                    "updated_at": "2017-01-26T15:41:15.872Z",
                    "owner_id": 1,
                    "attachment": {
                      "url": null
  }}

}`

* **Error Response:**

  <_Most endpoints will have many ways they can fail. From unauthorized access, to wrongful parameters etc. All of those are listed below._>

  * **Code:** 403 Forbidden <br />
    **Content:** `{ error: "Access denied" }`

  OR

  * **Code:** 404 Not Found <br />
    **Content:** `{ error : "Event not found" }`

* **Sample Call:**

  <_Pcurl -X PUT -H "Content-Type: application/json" -H "Cache-Control: no-cache" -H "Postman-Token: 28188d41-d102-aca3-0617-83d86258c97f" -d '{
	"comment":
	{
		"content":"Comment has been edited!"
	}

}' "http://localhost:3000/events/25/comments/2?auth_token=JFxBWnJcuTzPs8sok2iL" ._>

**Register User**
----
  Returns auth_token data about a single user.

* **URL**

  /users

* **Method:**

  `POST`

* **Data Params**

`{	"user":{"email" : "user@email.com","password" : "password","password_confirmation" : "password"}}	`

* **Success Response:**

  * **Code:** 200 <br />
    **Content:** `{"id": 1,"email": "user@email.com","created_at": "2017-01-26T16:53:41.548Z","updated_at": "2017-01-26T16:53:41.548Z","auth_token": "UL1-rYGSvLzDBWK4z19r"}`

* **Error Response:**

  * **Code:** 404 NOT FOUND <br />
    **Content:** `{ error : "User doesn't exist" }`

  OR

  * **Code:** 422 UNAUTHORIZED <br />
    **Content:** `{{"errors": {"email": ["is invalid"],"password": ["can't be blank"]}}`

* **Sample Call:**

  ```curl -X POST -H "Content-Type: application/json" -H "Cache-Control: no-cache" -H "Postman-Token: 4f7031fb-87b5-47f9-5972-d3d608674024" -d '{	"user":{
		"email" : "some_new@email.com",
		"password" : "qwqwqw",
		"password_confirmation" : "qwqwqw"
	}
}	' "http://localhost:3000/users"
  ```
  **Log Out User**
  ----
  * **URL**

    /users/sign_out

  * **Method:**

    `DELETE`

  *  **URL Params**

   **Required:**

   `auth_token=[string]`

  * **Data Params**


  * **Success Response:**

    * **Code:** 200 <br />
      **Content:** `{"id": 2,"email": "some_new@email.com","created_at": "2017-01-26T16:53:41.548Z","updated_at": "2017-01-26T17:02:18.282Z","auth_token": "yb51zter7SM72corPe-2"}`

  * **Error Response:**

    * **Code:** 404 NOT FOUND <br />
      **Content:** `{ error : "User doesn't exist" }`

    OR

    * **Code:** 422 UNAUTHORIZED <br />
      **Content:** `{"errors": "Invalid email or password"}`

  * **Sample Call:**

    `curl -X POST -H "Content-Type: application/json" -H "Cache-Control: no-cache" -H "Postman-Token: 4331ebf5-018b-2ff8-5bc7-09feaa765a29" -d '{"session":{"email" : "some_new@email.com","password" : "qwqwqw"}}'"http://localhost:3000/users/sign_in" `

    **Index Event**
    ----
      Returns data about all events of current user.

    * **URL**

      /events

    * **Method:**

      `GET`

    *  **URL Params**

     **Required:**

     `auth_token=[string]`

     **Optional:**

     `interval=[integer]`


    * **Data Params**

    `{"name" : "Some fantastic event2", "time" : "2017-01-28T17:18:51.367Z", "place" :"Some place666", "purpose" :"Some purpose",
	"attachment":"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAARgAAAEpCAIAAADHyqrTAAAkzUlEQVR..."}`

    * **Success Response:**

      * **Code:** 200 <br />
        **Content:** `{"id": 6,"name": "Some fantastic event2","time": "2017-01-28T17:18:51.367Z","place": "Some place666", "purpose": "Some purpose", "created_at": "2017-01-26T17:18:43.361Z", updated_at": "2017-01-26T17:18:43.375Z","owner_id": 1,"attachment": {  "url": "/uploads/event/attachment/6/event_file-1485451123.png"}}`

    * **Error Response:**

      * **Code:** 404 NOT FOUND <br />
        **Content:** `{ error : "Not found" }`

    * **Sample Call:**

      ```curl -X POST -H "Content-Type: application/json" -H "Cache-Control: no-cache" -H "Postman-Token:517ec428-f37b-3fa1-bd87-d7128a1dbe9d" -d '{	"name" : "Some fantastic event2", "time" : "2017-01-28T17:18:51.367Z", "place" :"Some place666", "purpose" :"Some purpose","attachment":"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAARgAAAEpCAIAAADHyqrTAAAkzUlEQVR..."
}' "http://localhost:3000/events/"
      ```
      **Create Event**
      ----
        Create an event with details and attachment.

      * **URL**

        /events

      * **Method:**

        `POST`

      *  **URL Params**

       **Required:**

       `id=[integer]`
       `auth_token=[string]`

      * **Data Params**

      `{"name" : "Some fantastic event2", "time" : "2017-01-28T17:18:51.367Z", "place" :"Some place666", "purpose" :"Some purpose",
    "attachment":"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAARgAAAEpCAIAAADHyqrTAAAkzUlEQVR..."}`

      * **Success Response:**

        * **Code:** 200 <br />
          **Content:** `{"id": 6,"name": "Some fantastic event2","time": "2017-01-28T17:18:51.367Z","place": "Some place666", "purpose": "Some purpose", "created_at": "2017-01-26T17:18:43.361Z", updated_at": "2017-01-26T17:18:43.375Z","owner_id": 1,"attachment": {  "url": "/uploads/event/attachment/6/event_file-1485451123.png"}}`

      * **Error Response:**

        * **Code:** 404 NOT FOUND <br />
          **Content:** `{ error : "Not found" }`

      * **Sample Call:**

        ```curl -X POST -H "Content-Type: application/json" -H "Cache-Control: no-cache" -H "Postman-Token:517ec428-f37b-3fa1-bd87-d7128a1dbe9d" -d '{	"name" : "Some fantastic event2", "time" : "2017-01-28T17:18:51.367Z", "place" :"Some place666", "purpose" :"Some purpose","attachment":"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAARgAAAEpCAIAAADHyqrTAAAkzUlEQVR..."
    }' "http://localhost:3000/events/"
    ```
    **Edit Event**
    ----
      Edit event details or attachment.

    * **URL**

      /events/:id/edit

    * **Method:**

      `PUT` | `PATCH`

    *  **URL Params**

     **Required:**

     `id=[integer]`
     `auth_token=[string]`

    * **Data Params**

    `{"name" : "Some new name", "time" : "2018-01-28T17:18:51.367Z", "place" :"Some new place", "purpose" :"Some new purpose"}`

    * **Success Response:**

      * **Code:** 200 <br />
        **Content:** `{"id": 6,"name": "SSome new name","time": "2018-01-28T17:18:51.367Z","place": "Some new place", "purpose": "ome new purpose", "created_at": "2017-01-26T17:18:43.361Z", updated_at": "2017-01-26T17:18:43.375Z","owner_id": 1,"attachment": {  "url": "/uploads/event/attachment/6/event_file-1485451123.png"}}`

    * **Error Response:**

      * **Code:** 404 NOT FOUND <br />
        **Content:** `{ error : "Not found" }`

    * **Sample Call:**

      ```curl -X PUT -H "Content-Type: application/json" -H "Cache-Control: no-cache" -H "Postman-Token: 97da1dd3-bc58-ea02-afba-cbfe9f737ab1" -d '{"name" : "Some new name", "time" : "2018-01-28T17:18:51.367Z", "place" :"Some new place", "purpose" :"Some new purpose"}' "http://localhost:3000/events?auth_token=Z5GJNoYLEoyA2nn-qyRM"
      ```

      **Delete Event**
      ----
        Delete event.

      * **URL**

        /events/:id

      * **Method:**

        `DELETE`

      *  **URL Params**

       **Required:**

       `auth_token=[string]`

      * **Data Params**


      * **Success Response:**

        * **Code:** 200 <br />
          **Content:** `{{"data": {"message": "Successfully deleted"}

      * **Error Response:**

        * **Code:** 404 NOT FOUND <br />
          **Content:** `{ error : "Not found" }`

      * **Sample Call:**

        ```curl -X DELETE -H "Content-Type: application/json" -H "Cache-Control: no-cache" -H "Postman-Token: 8d9829fb-576a-f587-631f-61479f66bbc7" -d '' "http://localhost:3000/events/7?auth_token=Kb5QL6y4dx78w2TicdbD"
        ```  
        **Index Comments**
        ----
          Returns comments of the event.

        * **URL**

          /events/:event_id/comments

        * **Method:**

          `GET`

        *  **URL Params**

         **Required:**
         `event_id=[integer]`
         `auth_token=[string]`

          **Create Comment**
          ----
            Create comment.

          * **URL**

            /events/:event_id/comments

          * **Method:**

            `POST`

          *  **URL Params**

           **Required:**

           `event_id=[integer]`
           `auth_token=[string]`

          * **Data Params**

          `{"comment": {" content": "Content of the comment}}`

        **Edit Comment**
        ----
          Edit comment.

        * **URL**

          /events/:event_id/comments/:id

        * **Method:**

          `PUT` | `PATCH`

        *  **URL Params**

         **Required:**

         `id=[integer]`
         `event_id=[integer]`
         `auth_token=[string]`

        * **Data Params**

        `{"comment": {" content": "New content of the comment}}`

          **Delete Comment**
          ----
            Delete comment.

          * **URL**

            /events/:event_id/comments/:id

          * **Method:**

            `DELETE`

          *  **URL Params**

           **Required:**

           `id=[integer]`
           `event_id=[integer]`
           `auth_token=[string]`

          * **Data Params**

          **Create Invitation**
          ----
            Invite other user to your event.

          * **URL**

            /invites

          * **Method:**

            `POST`

          *  **URL Params**

           **Required:**

           `auth_token=[string]`

          * **Data Params**

          `{"invite":{ "invitee_id":"3", "event_id": "1" }`
