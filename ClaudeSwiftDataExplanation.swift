# SwiftData Concepts Breakdown

## 1. @Model - Making Classes Persistable

```swift
@Model
class TodoItem {
    var title: String
    var isCompleted: Bool
    var createdAt: Date
    var categoryRawValue: String
    var sortOrder: Int
    
    init(title: String, category: TodoCategory = .personal, isCompleted: Bool = false) {
        self.title = title
        self.categoryRawValue = category.rawValue
        self.isCompleted = isCompleted
        self.createdAt = Date()
        self.sortOrder = Int(Date().timeIntervalSince1970)
    }
}
```

### **What @Model Does:**
- **Marks the class** for SwiftData persistence
- **Automatically generates** database schema from properties
- **Makes the class conform** to `Observable` for SwiftUI reactivity
- **Adds `id` property** automatically for `Identifiable`
- **Enables relationships** with other @Model classes

### **Supported Property Types:**
- **Primitives**: `String`, `Int`, `Bool`, `Date`, `Double`, etc.
- **Collections**: `Array`, `Set` (of supported types)
- **Optionals**: `String?`, `Int?`, etc.
- **Relationships**: Other `@Model` classes
- **NOT Supported**: Custom enums directly (hence our `categoryRawValue: String` workaround)

---

## 2. ModelContainer - The Database

```swift
@main
struct TodoApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
        .modelContainer(for: TodoItem.self)  // Creates the database
    }
}
```

### **What ModelContainer Does:**
- **Creates the SQLite database** file
- **Manages database connection** and lifecycle
- **Handles schema migrations** automatically
- **Provides the context** for all database operations
- **Can be configured** for in-memory, custom locations, etc.

### **Container Options:**
```swift
// Basic container
.modelContainer(for: TodoItem.self)

// In-memory for testing
.modelContainer(for: TodoItem.self, inMemory: true)

// Multiple models
.modelContainer(for: [TodoItem.self, Category.self])

// Custom configuration
let config = ModelConfiguration(isStoredInMemoryOnly: true)
let container = try ModelContainer(for: TodoItem.self, configurations: config)
```

---

## 3. @Query - Automatic Data Fetching

```swift
@Query(sort: [
    SortDescriptor(\TodoItem.sortOrder),
    SortDescriptor(\TodoItem.createdAt, order: .reverse)
]) private var todoItems: [TodoItem]
```

### **What @Query Does:**
- **Automatically fetches** data from the database
- **Updates the UI** when data changes (reactive)
- **Runs efficiently** - only fetches when needed
- **Supports filtering** and sorting
- **Works with SwiftUI** view updates

### **Query Examples:**

#### **Basic Query (All Items)**
```swift
@Query private var todoItems: [TodoItem]
```

#### **Sorted Query**
```swift
@Query(sort: \TodoItem.createdAt, order: .reverse)
private var todoItems: [TodoItem]
```

#### **Multiple Sort Descriptors**
```swift
@Query(sort: [
    SortDescriptor(\TodoItem.sortOrder),
    SortDescriptor(\TodoItem.createdAt, order: .reverse)
]) private var todoItems: [TodoItem]
```

#### **Filtered Query**
```swift
@Query(filter: #Predicate<TodoItem> { $0.isCompleted == true })
private var completedItems: [TodoItem]
```

#### **Complex Filtering**
```swift
@Query(filter: #Predicate<TodoItem> { item in
    item.isCompleted == false &&
    item.categoryRawValue == "Work"
}) private var pendingWorkItems: [TodoItem]
```

---

## 4. @Environment(\.modelContext) - Database Operations

```swift
@Environment(\.modelContext) private var context

// Insert new item
let newItem = TodoItem(title: "New Task")
context.insert(newItem)

// Delete item
context.delete(item)

// Save changes
try context.save()
```

### **What ModelContext Provides:**
- **Insert** new objects into the database
- **Delete** objects from the database
- **Save** changes to persist them
- **Undo/Redo** capabilities
- **Batch operations** for performance

### **Context Operations:**

#### **Creating and Inserting**
```swift
let newTodo = TodoItem(title: "Buy milk", category: .shopping)
context.insert(newTodo)
try context.save()
```

#### **Deleting**
```swift
context.delete(todoItem)
try context.save()
```

#### **Batch Operations**
```swift
// Delete multiple items
for item in itemsToDelete {
    context.delete(item)
}
try context.save()
```

#### **Error Handling**
```swift
do {
    try context.save()
} catch {
    print("Failed to save: \(error)")
}
```

---

## 5. #Predicate - Type-Safe Filtering

```swift
@Query(filter: #Predicate<TodoItem> { $0.isCompleted == true })
private var completedItems: [TodoItem]
```

### **What #Predicate Provides:**
- **Type-safe filtering** at compile time
- **Efficient database queries** (translated to SQL)
- **SwiftUI integration** for reactive updates
- **Complex logic support** with && and ||

### **Predicate Examples:**

#### **Simple Boolean Filter**
```swift
#Predicate<TodoItem> { $0.isCompleted == true }
```

#### **String Comparison**
```swift
#Predicate<TodoItem> { $0.categoryRawValue == "Work" }
```

#### **Date Filtering**
```swift
#Predicate<TodoItem> { $0.createdAt > Date().addingTimeInterval(-86400) }
```

#### **Complex Logic**
```swift
#Predicate<TodoItem> { item in
    item.isCompleted == false &&
    (item.categoryRawValue == "Work" || item.categoryRawValue == "Personal")
}
```

#### **Text Search**
```swift
#Predicate<TodoItem> { $0.title.contains("important") }
```

---

## 6. Computed Properties for Enums

```swift
var category: TodoCategory {
    get {
        TodoCategory(rawValue: categoryRawValue) ?? .personal
    }
    set {
        categoryRawValue = newValue.rawValue
    }
}
```

### **Why This Pattern:**
- **SwiftData requires primitives** (String, Int, etc.)
- **Enums aren't directly supported** in @Model classes
- **Computed properties provide** type-safe enum access
- **Raw values enable** database storage

### **How It Works:**
1. **Store as String**: `categoryRawValue: String` in the database
2. **Access as Enum**: `item.category` returns `TodoCategory`
3. **Automatic Conversion**: Getter converts String → Enum
4. **Safe Fallback**: `?? .personal` handles invalid stored values

---

## 7. Reactive UI Updates

```swift
// When you change a property...
item.isCompleted.toggle()
try context.save()

// SwiftData automatically:
// 1. Updates the database
// 2. Notifies @Query properties
// 3. Triggers SwiftUI view updates
```

### **How Reactivity Works:**
- **@Model classes** conform to `Observable`
- **Property changes** trigger notifications
- **@Query** listens for database changes
- **SwiftUI** automatically redraws affected views

### **What Updates Automatically:**
- **List items** when properties change
- **Filtered views** when items match/unmatch predicates
- **Sorted views** when sort-relevant properties change
- **Empty states** when items are added/removed

---

## 8. Model Relationships (Advanced)

```swift
// If you had categories as separate models:
@Model
class Category {
    var name: String
    var color: String
    @Relationship(deleteRule: .cascade) var todos: [TodoItem] = []
}

@Model
class TodoItem {
    var title: String
    var category: Category?  // Relationship
}
```

### **Relationship Types:**
- **To-One**: `var category: Category?`
- **To-Many**: `var todos: [TodoItem]`
- **Bidirectional**: Both sides reference each other

### **Delete Rules:**
- **`.cascade`**: Delete related objects
- **`.nullify`**: Set relationship to nil
- **`.deny`**: Prevent deletion if relationships exist

---

## 9. Migration and Schema Evolution

```swift
// SwiftData handles migrations automatically when you:
// 1. Add new properties
// 2. Remove properties
// 3. Change property types (with some limitations)

// Example: Adding a new property
@Model
class TodoItem {
    var title: String
    var isCompleted: Bool
    var priority: Int = 0  // NEW: Added later
}
```

### **Automatic Migrations:**
- **Adding properties**: Sets default values for existing data
- **Removing properties**: Drops columns safely
- **Renaming**: Requires custom migration

---

## 10. Performance Considerations

### **Efficient Queries:**
```swift
// Good: Specific filtering at database level
@Query(filter: #Predicate<TodoItem> { $0.isCompleted == false })
private var pendingItems: [TodoItem]

// Less Efficient: Filtering in memory
@Query private var allItems: [TodoItem]
var pendingItems: [TodoItem] { allItems.filter { !$0.isCompleted } }
```

### **Batch Operations:**
```swift
// Efficient: Single save for multiple operations
for item in itemsToUpdate {
    item.isCompleted = true
}
try context.save()  // Single database transaction

// Less Efficient: Multiple saves
for item in itemsToUpdate {
    item.isCompleted = true
    try context.save()  // Multiple transactions
}
```

---

## Key SwiftData Benefits in Our Todo App:

### **🎯 Simplicity**
- **No boilerplate** - just add @Model and @Query
- **Automatic UI updates** - no manual refresh needed
- **Type safety** - compile-time checking

### **🚀 Performance**
- **Efficient queries** - translated to optimized SQL
- **Lazy loading** - only fetches what's needed
- **Automatic batching** - groups operations efficiently

### **🔧 Developer Experience**
- **SwiftUI integration** - works seamlessly with views
- **Preview support** - in-memory containers for testing
- **Automatic migrations** - handles schema changes

This makes SwiftData perfect for iOS apps that need local data persistence with minimal complexity!
