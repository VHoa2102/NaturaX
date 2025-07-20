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
    calculateHash(); 
}

Block::~Block() {}

void Block::calculateHash() {
    std::string sum; 
    for (const auto& tx: transactions) {
        sum+=tx.gpsLocation;
        sum+=tx.greenActionType;
        sum+=tx.userID; 
        sum+=std::to_string(tx.timestamp); 
        sum+=std::to_string(tx.greenPoints);
    }

    uint32_t buffersize=SHA256_DIGEST_LENGTH+sizeof(time_t)+sum.size()+sizeof(uint32_t); 
    uint8_t* buf=new uint8_t[buffersize]; 
    uint8_t* ptr=buf; 
    memcpy(ptr, PreviousHash, SHA256_DIGEST_LENGTH*sizeof(uint8_t));
    ptr+=SHA256_DIGEST_LENGTH*sizeof(uint8_t);

    memcpy(ptr, &createTimestamp, sizeof(time_t));
    ptr+=sizeof(time_t); 

    memcpy(ptr, &Nonce, sizeof(uint32_t));
    ptr+=sizeof(uint32_t);

    memcpy(ptr, sum.c_str(), sum.size()); 

    SHA256_CTX sha256; 
    SHA256_Init(&sha256); 
    SHA256_Update(&sha256, buf, buffersize);
    SHA256_Final(Hash, &sha256); 
    
    delete[] buf; 
    
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
    SHA256_CTX sha256; 
    SHA256_Init(&sha256);
    std::string sum; 
    for (const auto& tx: transactions) {
        sum+=tx.gpsLocation;
        sum+=tx.greenActionType;
        sum+=tx.userID; 
        sum+=std::to_string(tx.timestamp); 
        sum+=std::to_string(tx.greenPoints);
    }

    uint32_t buffersize=SHA256_DIGEST_LENGTH+sizeof(time_t)+sum.size()+sizeof(uint32_t); 
    uint8_t* buf=new uint8_t[buffersize]; 
    uint8_t* ptr=buf; 
    memcpy(ptr, PreviousHash, SHA256_DIGEST_LENGTH*sizeof(uint8_t));
    ptr+=SHA256_DIGEST_LENGTH*sizeof(uint8_t);

    memcpy(ptr, &createTimestamp, sizeof(time_t));
    ptr+=sizeof(time_t); 

    memcpy(ptr, &Nonce, sizeof(uint32_t));
    ptr+=sizeof(uint32_t);

    memcpy(ptr, sum.c_str(), sum.size()); 

    SHA256_Update(&sha256, buf, buffersize);
    SHA256_Final(tmpHash, &sha256); 
    
    delete[] buf; 

    return memcmp(tmpHash, Hash, SHA256_DIGEST_LENGTH)==0;
}

