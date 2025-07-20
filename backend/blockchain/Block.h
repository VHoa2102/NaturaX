#ifndef BLOCK_H
#define BLOCK_H

#include <iostream>
#include <vector>
#include <ctime>
#include <sstream>
#include <string.h>
#include <stdio.h>
#include <string>
#include <openssl/sha.h>

namespace blockchain {
    struct Transaction {
        std::string timestamp; 
        std::string gpsLocation; 
        std::string userID; 
        std::string greenActionType; 
        int greenPoints; 
    };
    class Block {
    private: 
        uint8_t Hash[SHA256_DIGEST_LENGTH];                     //mã băm block hiện tại
        uint8_t PreviousHash[SHA256_DIGEST_LENGTH];             //mã băm block trước
        Block* prevBlock;                                       //con trỏ trỏ đến block trước, trỏ null
        std::vector<Transaction> transactions;  
        uint32_t DataSize;
        time_t createTimestamp; 
        uint32_t Nonce; 
    public: 
        Block(Block* prevBlock);                                //constructor
        ~Block();                                               //destructor
        void calculateHash();                                   //tính toán hash
        const uint8_t* getHash() const;                         //getter hash (dùng để lấy dữ liệu hash)    
        std::string getHashstr();                               //gettter hash dạng string
        Block* getprevBlock();                                  //hàm gettter Block trước đó
        std::vector<Transaction> getTransaction() const;        //getter transaction ra (struct ở trên)
        bool addTransaction(const Transaction& tx);             //thêm transaction vào blockchain
        //uint32_t getDataSize() const; 
        uint32_t getNonce() const; 
        time_t getTimestamp() const; 
        bool isDifficult(int difficulty);                       //xét proof of work, nếu thoả thì thêm vào blockchain
        void mine(int difficulty); 
        bool verifyHash() const;                                //kiểm tra tính hợp lệ của block    
    };
}
#endif
