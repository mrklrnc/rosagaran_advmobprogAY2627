# rosagaran_mobile

A new Flutter project.

# Lab Activity 1: Discussion

The difference between setState and Provider is that setState is used to manage local states that belong to a single widget like the counter. And the provider is for an app wide state it allows multiple widgets to access the same data.

# Lab Activity 2: Discussion

The model, service, and screen work together to get and show data from the API. The model stores the product information, the service gets the data from the API, and the screen shows it to the user. This makes the app organized because each part has one clear job. The new design pattern here is a layered structure, where data, logic, and UI are separated.

# Lab Activity 3: Discussion

The cart model stores the cart data, CartService gets it from the API, and CartScreen shows it on the UI. When a cart item is tapped, its product id is passed to detail_screen.dart.
getById is used to fetch the full product details from that id, so the cart and product list can both open the same detail screen. This design is cleaner because it reuses one screen instead of making another one.

# Lab Activity 4: Discussion

The user model stores the user information, UserService handles authentication with the API login endpoint, and ProfileScreen displays the user profile details. The updated design pattern in this activity introduces persistent state and session management using SharedPreferences into the layered architecture, allowing the app to keep the user logged in across restarts.

When the user logs in, their user ID is saved to local storage. HomeScreen retrieves this saved ID and passes it to CartScreen, allowing CartService to fetch and render the specific cart belonging to the authenticated user instead of using a hardcoded ID.
