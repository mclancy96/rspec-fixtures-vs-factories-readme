# RSpec: Fixtures vs Factories: Test Data in Rails

Welcome to Lesson 23! In this lesson, you'll learn the difference between Rails fixtures and FactoryBot factories for setting up test data in your specs. We'll explain what each approach is, how they work, and why most modern Rails projects prefer factories. We'll also show you best practices for writing maintainable, DRY, and flexible factories. If you know Ruby and Rails but are new to automated testing, this is your essential guide to test data!

---

## Why Do We Need Test Data?

Automated tests need data to work with—users, posts, comments, etc. You want your tests to be realistic, repeatable, and easy to maintain. There are two main ways to set up test data in Rails:

- **Fixtures** (built-in to Rails)
- **Factories** (via FactoryBot)

---

## What Are Fixtures?

Fixtures are YAML files that define sample data for your models. Rails loads them before each test run.

```yaml
# /test/fixtures/users.yml
bob:
  username: bob
  email: bob@example.com

alice:
  username: alice
  email: alice@example.com
```

In your tests, you can reference these records by name:

```ruby
# /test/models/user_test.rb
user = users(:bob)
```

**Pros:**

- Built into Rails
- Easy to get started
- Good for small, static datasets

**Cons:**

- Hard to customize per test
- Can get out of sync with your models
- Not DRY if you need lots of variations
- Not as flexible for complex associations

**Example Limitation:**

Suppose you want to create a user with a different email just for one test:

```ruby
# With fixtures (not easy to override):
user = users(:bob)
user.email = "new@email.com" # This change won't persist between tests!
```

With factories, you can do this easily:

```ruby
user = create(:user, email: "new@email.com")
```

---

## What Are Factories?

Factories are Ruby code (usually with FactoryBot) that define blueprints for creating test data on the fly.

```ruby
# /spec/factories/users.rb
FactoryBot.define do
  factory :user do
    username { "testuser" }
    email { "test@example.com" }
  end
end
```

In your specs, you can create users as needed:

```ruby
# /spec/models/user_spec.rb
user = create(:user)
```

Or, using RSpec's `let` for even cleaner setup:

```ruby
# /spec/models/user_spec.rb
RSpec.describe User do
  let(:user) { create(:user) }
  # ...your tests here...
end
```

**Pros:**

- Flexible and customizable for each test
- DRY: define once, use everywhere
- Can easily create associated records
- Works great with RSpec and modern Rails

**Cons:**

- Slightly more setup (need to install FactoryBot)
- Can be slower if you create lots of records

---

## Example: Creating Associated Data

With fixtures, associations are defined in YAML:

```yaml
# /test/fixtures/posts.yml
first_post:
  title: First Post
  user: bob
```

With factories, you can use associations:

```ruby
# /spec/factories/posts.rb
FactoryBot.define do
  factory :post do
    title { "A blog post" }
    association :user
  end
end
```

And in your spec:

```ruby
# /spec/models/post_spec.rb
post = create(:post)
expect(post.user).to be_present
```

---

## Best Practices for Maintainable Factories

- Use sequences for unique fields:

```ruby
# /spec/factories/users.rb
factory :user do
  sequence(:username) { |n| "user#{n}" }
  email { "user@example.com" }
end
```

- Use traits for variations:

```ruby
# /spec/factories/users.rb
factory :user do
  trait :admin do
    admin { true }
  end
end
```

- Use associations to build related data
- Keep factories DRY and simple—avoid callbacks or business logic
- Prefer `build_stubbed` for faster tests when you don't need to hit the database (it builds objects in memory without saving them, so your tests run faster)

---

## Visual: How Factories Build Associated Data

Here's a simple diagram showing how factories can generate associated records dynamically:

```zsh
create(:post)
  |
  |---> FactoryBot builds a Post
         |
         |---> FactoryBot automatically builds a User (association)
```

---

## When Should You Use Fixtures?

- For legacy Rails projects that already use them
- For very simple, static data that never changes
- When you want to test against a known, fixed dataset

## When Should You Use Factories?

- For most modern Rails projects
- When you want flexible, customizable, and DRY test data
- When you need to create complex or associated records
- When you want your tests to be readable and maintainable

---

## Practice Prompts & Reflection Questions

1. Write a fixture for a model and use it in a test. What are the limitations?
2. Write a factory for a model and use it in a spec. How does it compare to fixtures?
3. Add a trait to a factory for a variation (e.g., admin user). How do you use it in a spec?
4. Create a factory with an association. How does FactoryBot handle related records?
5. Why might factories be more maintainable than fixtures in a growing codebase?

Reflect: What could go wrong if your test data is hard to change or doesn't match your real app?

---

## What's Next?

Lab 7 is next! In Lab 7, you'll write model, request, and feature specs for a Rails mini-app. This is your opportunity to put everything you've learned about test data, factories, and RSpec into practice on a real Rails project.

---

## Resources

- [Rails Guides: Fixtures](https://guides.rubyonrails.org/testing.html#the-low-down-on-fixtures)
- [FactoryBot Documentation](https://github.com/thoughtbot/factory_bot)
- [Better Specs: Factories](https://www.betterspecs.org/#factories)
- [Thoughtbot: Factories vs Fixtures](https://thoughtbot.com/blog/factories-not-fixtures)
