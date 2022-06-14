# Hooks-For-Devs

- Here are some Hooks for Gitlab and Github, concerning naming convention.

- To help project managers and other collaborators to fully understand the progress of each project, compliance with the naming convention is supported by hooks which will allow each commit to be verified, and thus accept or not the pushes.

# How to install ?

- First, clone the repository somewhere on your desktop.

- Then, go into your project repository and find à directory called « .git ». Inside go into hooks folder. The .git directory is hidden by default, check (in windows) the case ‘display hiddenn files, folders and drives’ in your folder’s options.

- Copy the three files named : pre-commit, commit-msg and post-commit into the hooks folder.

- That’s all, now when you are going to commit, those three hooks will check it and accept or not the message.

# Gerhard Eibl