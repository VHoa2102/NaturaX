#include "Block.h"

using namespace blockchain; 

Block::Block(Block* prevBlock) {
    this->prevBlock=prevBlock; 
    if (prevBlock!=nullptr) {
        memcpy(this->PreviousHash, prevBlock->getHash(), SHA256_DIGEST_LENGTH);         //tồn tại prevBlock thì gán nó cho prevHash 
    }
    else {
        memset(this->PreviousHash, 0, SHA256_DIGEST_LENGTH);                            //không có thì khởi tạo là 0
    }
    Nonce=0; 
    createTimestamp=time(0); 
    DataSize=0; 
    calculateHash(); 
}

Block::~Block() {}

void Block::calculateHash() {

}

const uint8_t* Block::getHash() const {
    return Hash; 
}

std::string Block::getHashstr() {                                                      //đưa mã hash về dạng string
    char sub[SHA256_DIGEST_LENGTH*2+1];
    for (uint32_t i=0; i<SHA256_DIGEST_LENGTH; i++) {
        sprintf(&sub[i*2], "%02x", Hash[i]);                                           //print 1 string có độ dài 64 bằng mã hex từ vị trí i đến hết
    }
    sub[SHA256_DIGEST_LENGTH*2]='\0';
    return std::string(sub); 
}

Block* Block::getprevBlock() {
    return prevBlock; 
}

std::vector<Transaction> Block::getTransaction() const {
    return transactions; 
}

bool Block::addTransaction(const Transaction& tx) {        
    if (tx.userID.empty() || tx.greenPoints==0 || tx.greenActionType.empty()) return false;
    transactions.push_back(tx); 
    return true;
}

uint32_t Block::getNonce() const {
    return Nonce; 
}

time_t Block::getTimestamp() const {
    return createTimestamp; 
}

bool Block::isDifficult(int difficulty) {                                              //cơ chế proof of work
    for (uint32_t i=0; i<difficulty; i++) {
        if (Hash[i]!=0) return false;
    }
    return true; 
}

void Block::mine(int difficulty) {
    while(isDifficult(difficulty)) {
        Nonce++;                                                                       //tính toán lại cho đến khi tìm được Nonce thoả
        calculateHash();    
    }
}

bool Block::verifyHash() const {
    uint8_t tmpHash[SHA256_DIGEST_LENGTH]; 

}

