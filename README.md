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

alice:

```yaml
# /test/fixtures/volunteers.yml
alice:
  name: Alice
  organization: org_one
bob:
  name: Bob
  organization: org_two
```

In your tests, you can reference these records by name:

```ruby
# /spec/models/volunteer_spec.rb
volunteer = volunteers(:alice)
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
volunteer = volunteers(:alice)
volunteer.name = "New Name" # This change won't persist between tests!
```

With factories, you can do this easily:

```ruby
volunteer = create(:volunteer, name: "New Name")
```

---

## What Are Factories?

Factories are Ruby code (usually with FactoryBot) that define blueprints for creating test data on the fly.

```ruby
# /spec/factories/volunteers.rb
FactoryBot.define do
  factory :volunteer do
    sequence(:name) { |n| "Volunteer#{n}" }
    association :organization
  end
end
```

In your specs, you can create users as needed:

```ruby
# /spec/models/volunteer_spec.rb
volunteer = create(:volunteer)
```

Or, using RSpec's `let` for even cleaner setup:

```ruby
# /spec/models/volunteer_spec.rb
RSpec.describe Volunteer do
  let(:volunteer) { create(:volunteer) }
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
# /test/fixtures/shifts.yml
morning:
  starts_at: 2025-09-01 08:00:00
  ends_at: 2025-09-01 12:00:00
  organization: org_one
```

With factories, you can use associations:

```ruby
# /spec/factories/shifts.rb
FactoryBot.define do
  factory :shift do
    starts_at { 1.day.from_now }
    ends_at { 2.days.from_now }
    association :organization
  end
end
```

And in your spec:

```ruby
# /spec/models/shift_spec.rb
shift = create(:shift)
expect(shift.organization).to be_present
```

---

## Best Practices for Maintainable Factories

- Use sequences for unique fields:

```ruby
# /spec/factories/volunteers.rb
factory :volunteer do
  sequence(:name) { |n| "Volunteer#{n}" }
  association :organization
end
```

- Use traits for variations:

```ruby
# /spec/factories/volunteers.rb
factory :volunteer do
  trait :lead do
    # add lead-specific attributes here
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
create(:shift)
  |
  |---> FactoryBot builds a Shift
         |
         |---> FactoryBot automatically builds an Organization (association)
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

## Getting Hands-On: Volunteer Coordination (Fixtures & Factories)

Ready to practice? Here’s how to get started with the Volunteer Coordination Rails app:

1. **Fork and Clone** this repo to your local machine.
2. **Install dependencies:**

   ```zsh
   bundle install
   ```

3. **Set up the database:**

   ```zsh
   bin/rails db:migrate
   ```

4. **Run the test suite:**

   ```zsh
   bin/rspec
   ```

5. **Implement the pending specs:**
   - Open `spec/models/volunteer_spec.rb`, `spec/models/shift_spec.rb`, and `spec/models/organization_spec.rb`.
   - Look for specs marked with `skip` and a hint. Implement the corresponding trait or association in the factories or fixtures so all specs pass.

### Example: Volunteer Model Spec (FactoryBot)

```ruby
# spec/models/volunteer_spec.rb
RSpec.describe Volunteer, type: :model do
  context 'with FactoryBot' do
    it 'is valid with valid attributes' do
      volunteer = build(:volunteer)
      expect(volunteer).to be_valid
    end
    # ...more examples...
  end
end
```

### Example: Volunteer Model Spec (Fixtures)

```ruby
# spec/models/volunteer_spec.rb
RSpec.describe Volunteer, type: :model do
  context 'with fixtures' do
    fixtures :volunteers, :organizations
    it 'loads a volunteer from fixtures' do
      expect(volunteers(:alice)).to be_a(Volunteer)
    end
    # ...more examples...
  end
end
```

---

## Reflection

- What are the tradeoffs between using fixtures and factories?
- How does each approach affect test maintainability as your app grows?
- What could go wrong if your test data is hard to change or doesn't match your real app?

---

## What's Next?

Lab 7 is next! In Lab 7, you'll write model, request, and feature specs for a Rails mini-app. This is your opportunity to put everything you've learned about test data, factories, and RSpec into practice on a real Rails project.

---

## Resources

- [Rails Guides: Fixtures](https://guides.rubyonrails.org/testing.html#the-low-down-on-fixtures)
- [FactoryBot Documentation](https://github.com/thoughtbot/factory_bot)
- [Better Specs: Factories](https://www.betterspecs.org/#factories)
- [Thoughtbot: Factories vs Fixtures](https://thoughtbot.com/blog/factories-not-fixtures)
