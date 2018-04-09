package com.centennialcollege.brogrammers.businesschatapp.model;

/**
 * Model class to store information about one single chat item to be displayed on chat list screen.
 */

public class ChatListItem {

    private String chatId;
    private String chatName;
    private Message lastMessage;

    public ChatListItem() {
    }

    public String getChatName() {
        return chatName;
    }

    public void setChatName(String chatName) {
        this.chatName = chatName;
    }

    public Message getLastMessage() {
        return lastMessage;
    }

    public void setLastMessage(Message lastMessage) {
        this.lastMessage = lastMessage;
    }

    public String getChatId() {
        return chatId;
    }

    public void setChatId(String chatId) {
        this.chatId = chatId;
    }

}