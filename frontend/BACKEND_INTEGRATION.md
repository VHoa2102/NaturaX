# SpringR Frontend - Backend Integration

This document explains how to integrate your Node.js/Express backend controllers with the Flutter frontend.

## Backend API Endpoints

Based on your backend controllers, you should have these endpoints:

### Profile Endpoints
- `POST /profile` - Create profile
- `GET /profile/me` - Get current user's profile  
- `PUT /profile` - Update profile

### Post Endpoints
- `POST /posts` - Create post
- `GET /posts/me` - Get current user's posts
- `PUT /posts/:id` - Update post
- `DELETE /posts/:id` - Delete post

## Flutter Integration

### 1. Models
Created Flutter models that match your backend data structure:
- `ProfileModel` (`lib/models/profile_model.dart`)
- `PostModel` (`lib/models/post_model.dart`)
- `ApiResponse` (`lib/models/api_response.dart`) - For handling API responses

### 2. API Service
Created `ApiService` (`lib/services/api_service.dart`) that handles all HTTP communication with your backend:
- All CRUD operations for profiles and posts
- Proper error handling
- Token-based authentication

### 3. State Management (Providers)
Created providers for managing application state:
- `ProfileProvider` (`lib/providers/profile_provider.dart`)
- `PostProvider` (`lib/providers/post_provider.dart`)

### 4. Token Storage
Created `TokenStorage` (`lib/services/token_storage.dart`) for secure token management using FlutterSecureStorage.

### 5. Example UI Pages
Created example pages showing how to use the providers:
- `ProfilePage` (`lib/pages/profile_page.dart`)
- `PostsPage` (`lib/pages/posts_page.dart`)

## Configuration

### 1. Update Backend URL
Update `lib/services/config.dart` with your actual backend URL:
```dart
final url = 'http://your-backend-url:3000/';
```

### 2. Authentication Integration
You need to integrate with your existing authentication system:

1. After successful login, save the JWT token:
```dart
await TokenStorage.saveToken(jwtToken);
```

2. For logout, clear the token:
```dart
await TokenStorage.deleteToken();
```

## Usage Examples

### Using ProfileProvider
```dart
// Get profile
await context.read<ProfileProvider>().getMyProfile(token);

// Create profile
await context.read<ProfileProvider>().createProfile(
  token: token,
  fullName: 'John Doe',
  bio: 'Software Developer',
  address: '123 Main St',
);

// Update profile
await context.read<ProfileProvider>().updateProfile(
  token: token,
  fullName: 'Jane Doe',
);
```

### Using PostProvider
```dart
// Get posts
await context.read<PostProvider>().getMyPosts(token);

// Create post
await context.read<PostProvider>().createPost(
  token: token,
  title: 'My First Post',
  content: 'This is the content of my post',
);

// Update post
await context.read<PostProvider>().updatePost(
  token: token,
  postId: postId,
  title: 'Updated Title',
);

// Delete post
await context.read<PostProvider>().deletePost(
  token: token,
  postId: postId,
);
```

### Consuming Data in UI
```dart
Consumer<ProfileProvider>(
  builder: (context, profileProvider, child) {
    if (profileProvider.isLoading) {
      return CircularProgressIndicator();
    }
    
    if (profileProvider.errorMessage != null) {
      return Text('Error: ${profileProvider.errorMessage}');
    }
    
    final profile = profileProvider.profile;
    if (profile != null) {
      return Text('Hello, ${profile.fullName}!');
    }
    
    return Text('No profile found');
  },
)
```

## Backend Route Configuration

Make sure your backend routes match the API service calls:

```javascript
// Profile routes
app.post('/profile', authMiddleware, profileController.createProfile);
app.get('/profile/me', authMiddleware, profileController.getMyProfile);
app.put('/profile', authMiddleware, profileController.updateProfile);

// Post routes
app.post('/posts', authMiddleware, postController.createPost);
app.get('/posts/me', authMiddleware, postController.getMyPosts);
app.put('/posts/:id', authMiddleware, postController.updatePost);
app.delete('/posts/:id', authMiddleware, postController.deletePost);
```

## Error Handling

The providers automatically handle errors and provide error messages through:
- `profileProvider.errorMessage`
- `postProvider.errorMessage`

## Loading States

Loading states are available through:
- `profileProvider.isLoading`
- `postProvider.isLoading`

## Next Steps

1. Update the backend URL in `config.dart`
2. Integrate with your authentication system
3. Test the API endpoints
4. Customize the UI pages according to your design
5. Add more providers as needed for other features

## Notes

- Make sure your backend CORS settings allow requests from your Flutter app
- The JWT token should be included in the Authorization header as "Bearer [token]"
- All date fields are automatically parsed to DateTime objects
- The providers use ChangeNotifier for reactive UI updates
