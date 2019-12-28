# Text MMO

This project is in the early stages of its back-end development. Everything is subject to change.

## Getting started

1. Install [Ruby](https://rubyinstaller.org/)
2. Fork the repository
3. Clone the forked repo
4. In a terminal, navigate to the project
5. `$ bundle`

There is currently no entry point to "start" the game. However, there is a `battle_test.rb` file that is being used to test the development of the battle engine. You can run it by doing:

`$ ruby battle_test.rb`

You can look at the file to see what NPC it chooses to fight.

## Want to contribute?

Not all pull requests are going to be merged willy-nilly. There are four stages of a feature's lifecycle:

1. Design
2. Design review
3. Development
4. Code review

### Design

Create an issue, and add the "design" label. Begin laying out your thoughts of the feature, and finalize it with community feedback.

After debate, you will receive the green light to submit a pull request to integrate your feature into the game's design. 

However, if you cannot pursuade the community that your feature fits into the rest of the game's design, it will not be pursued. Refine your idea with the received constructive criticism and try again.

### Design review

Your feature has been green-lighted. The community wants it integrated into the game's design. Now you need to polish it up.

Fork the repository, copy and paste the `text-mmo/docs/design/feature-design-example.md` under `text-mmo/docs/design` in the proper directory that suits your feature. Rename the file in kebab-case, i.e. `rune-scimitar.md`, `lesser-healing-potion.md`,  etc. **Follow the design example.**

When your designs are ready for review, submit a pull request with a "design review" label.

Maintainers will assess the semantics of your design, and any last-minute debates need to be settled. **At this stage, do not add or change any mechanics unless they mitigate a game-breaking flaw.**

When approved, the "design review" label should be removed and "in development" should be added.

### Development

Your designs have been reviewed and approved by the community. Now it's time to get it built. 

Create an issue for the development of your feature. Add a link to your pull request. If you aren't a developer, collaborate with one so they can clone your fork and get started. Work with them to ensure your feature has been built correctly. 

### Code review

When you have deemed your feature complete, remove the "in development" label and add "code review". Maintainers will now assess the implementation of your feature and work with developers to ensure it is clean and bug-free. 

### All done!

Thank you for your contribution! Your feature has completed its lifecycle. You've spent hours designing and debating with community members, and many more developing the feature. Every player can now experience the fruits of your hard work. Now onto the next! ;)
