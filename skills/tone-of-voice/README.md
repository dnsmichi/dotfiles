# Tone of voice skill for dnsmichi - Michael Friedrich

The `dnsmichi-voice` skill captures how I actually write, so AI tools can help me ship content faster without the output needing a full rewrite. The dnsmichi-voice skill captures how I actually write, so AI tools can help me ship content faster without the output needing a full rewrite. One file of explicit rules, and the voice stays mine.

## Usage

### Glean

_Scope: Write blog posts, CfP abstracts, automate (internal) summaries._

In the [Glean macOS app](https://handbook.gitlab.com/handbook/business-technology/enterprise-applications/guides/glean-guide/#access), navigate to `Profile > Settings > Skills` and add a new Skill.

If the file upload does not work, use the assistant, and copy-paste the content from `SKILL.md`.

In a new or existing chat, click the `+` icon to load the new Skill, and then say `Use my tone of voice for creating this content`.

### Claude Desktop

_Scope: Write blog posts, CfP abstracts, content summaries, community forum help, code and project documentation._

Open the [Claude Desktop app on macOS](https://handbook.gitlab.com/handbook/tools-and-tips/ai/claude/#applications-and-cli). Navigate to `Chat > Customize` in the upper left corner. Upload a new skill using the [SKILL.md](SKILL.md) in this repository.

Then prompt Claude with

```markdown
Hey Claude—I just added the “dnsmichi-voice” skill. Can you make something amazing with it?
```

### Claude Code

_Scope: Write blog posts, CfP abstracts, content summaries, community forum help, code and project documentation._

```shell
cd ~/dev/work
git clone https://gitlab.com/dnsmichi/dotfiles.git && cd dotfiles

mkdir -p ~/.claude/skills/

ln -s `pwd`/skills/tone-of-voice ~/.claude/skills/tone-of-voice

ls -lah ~/.claude/skills/
```

Then open Claude Code:

```shell
claude

/skills
```

### GitLab Duo Agent Platform

_Scope: Write blog posts, code and project documentation, work item creation/comments, etc.._

Follow https://docs.gitlab.com/user/duo_agent_platform/customize/agent_skills/

Clone the repository locally, and create a symlink for the Skill:

```shell
cd ~/dev/work
git clone https://gitlab.com/dnsmichi/dotfiles.git && cd dotfiles

mkdir -p ~/.gitlab/duo/skills/

ln -s `pwd`/skills/tone-of-voice ~/.gitlab/duo/skills/tone-voice

ls -lah ~/.gitlab/duo/skills/
```

Then open Duo CLI:

```shell
export GITLAB_ENABLE_GLOBAL_SKILLS=true

duo

/skills

load this skill into the current session, and then write a narrative
  about why I like Duo Agent Platform.
```


## Skill training

_Note: Claude offered Memory first and knows a lot about my writing style._

Enable Claude Memory, and encourage it to store tone of voice learnings when necessary: `Store this tone of voice learning in your memory`.

After a while, ask it to regenerate/update this Skill content file.


## References

- Thanks to @josephburnett for the [inspiration](https://gitlab.com/-/snippets/5937873)
- [Dev Advocacy - Agentic AI use cases](https://gitlab.com/groups/gitlab-com/marketing/developer-relations/-/work_items/547) (internal)
