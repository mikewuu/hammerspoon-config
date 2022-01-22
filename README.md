# Hammerspoon Config

My config for Hammerspoon. For those that don't know, [Hammerspoon](hammerspoon.org) is a Mac util that let's you write Lua scripts to control your system.

I'm using it with an MX Ergo and a custom keyboard to gain back functionality I lost from moving away from an Apple hardware.

## Install

To install, clone into ~/.hammerspoon

```
git clone https://github.com/mikewudev/hammerspoon-config ~/.hammerspoon
```

## Right click + Trackball to Scroll

Switching to a trackball like the MX Ergo, and losing the Magic Mouse's scroll was a big deal for me. This gives me multi-directional scroll back.

## Custom Mouse Button Actions

Logicool Options allowed my MX Ergo to have programmable buttons. I found it slow and it couldn't do everything I wanted. This let's me ditch Logicool, and allows me to program dynamic app-aware actions.

Example: Mouse Button 4 does `cmd + ]` in every app, but `cmd + ctrl + ->` in XCode.

## F keys to Media Keys

Wish you could control your mac media keys (play/pause, volume, brightness) using an external keyboard? Use this.

I was previously using Karabiner Elements, which is a terrific app that's more user-friendly than Hammerspoon. Unforunately recent updates have produced a consistent key-stuck issue for my keyboard.

## Global Shortcuts with Hyper Key

Let's you bind shortcuts in any app. Some shortcut examples:

- launch/activate an app
- map numbers to F keys
- Launch spoons (hammerspoon modules)
- Execute an apple script. I use it to start work by launching a vm, ssh etc.


## Shift Parenthesis

Inspired by QMK's tap-dance feature, tap shift for ()

- Hold = shift
- 1 tap = (
- 2 taps = {
- 3 taps = [

## Prevent Switching to Bluetooth Mic

Whenever I connected my airpods, the bluetooth on my keyboard and airpods would stutter. After reading the mac will automatically switch to the airpod's mic, I [copied](http://ssrubin.com/posts/fixing-macos-bluetooth-headphone-audio-quality-issues-with-hammerspoon.html) this script to disable auto-input switching.


## Spoons

- Popup translation




