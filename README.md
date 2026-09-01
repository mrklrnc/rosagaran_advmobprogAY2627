# rosagaran_mobile

A new Flutter project.

# Lab Activity 1: Discussion

The difference between setState and Provider is that setState is used to manage local states that belong to a single widget like the counter. And the provider is for an app wide state it allows multiple widgets to access the same data.

# Lab Activity 2: Discussion

The model, service, and screen work together to get and show data from the API. The model stores the product information, the service gets the data from the API, and the screen shows it to the user. This makes the app organized because each part has one clear job. The new design pattern here is a layered structure, where data, logic, and UI are separated.

# Lab Activity 3: Discussion

The cart model stores the cart data, CartService gets it from the API, and CartScreen shows it on the UI. When a cart item is tapped, its product id is passed to detail_screen.dart.
getById is used to fetch the full product details from that id, so the cart and product list can both open the same detail screen. This design is cleaner because it reuses one screen instead of making another one.
