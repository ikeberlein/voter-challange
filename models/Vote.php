<?php

namespace app\models;

use Yii;
use yii\db\ActiveQuery;

/**
 * This is the model class for table "votes".
 *
 * @property int $user_id
 * @property int $candidate_user_id
 * @property string $vote
 *
 * @property User $user
 * @property User $candidateUser
 */
class Vote extends \yii\db\ActiveRecord {
	const LIKE = 'L';
	const DISLIKE = 'D';

	/**
	 * {@inheritdoc}
	 */
	public static function tableName() {
		return 'votes';
	}

	/**
	 * {@inheritdoc}
	 */
	public function rules() {
		return [
			[['user_id', 'candidate_user_id', 'vote'], 'required'],
			[['user_id', 'candidate_user_id'], 'default', 'value' => NULL],
			[['user_id', 'candidate_user_id'], 'integer'],
			[['vote'], 'string', 'max' => 1],
			[['vote'], 'in', 'range' => [self::LIKE, self::DISLIKE], 'message' => 'Vote should be either \'L\' for Like or \'D\' for Dislike'],
			[['user_id', 'candidate_user_id'], 'unique', 'targetAttribute' => ['user_id', 'candidate_user_id']],
			[['user_id'], 'exist', 'skipOnError' => TRUE, 'targetClass' => User::class, 'targetAttribute' => ['user_id' => 'id']],
			[['candidate_user_id'], 'exist', 'skipOnError' => TRUE, 'targetClass' => User::class, 'targetAttribute' => ['candidate_user_id' => 'id']],
		];
	}

	/**
	 * {@inheritdoc}
	 */
	public function attributeLabels() {
		return [
			'user_id' => 'User ID',
			'candidate_user_id' => 'Candidate User ID',
			'vote' => 'Vote',
		];
	}

	/**
	 * @return ActiveQuery
	 */
	public function getUser() {
		return $this->hasOne(User::class, ['id' => 'user_id']);
	}

	/**
	 * @return ActiveQuery
	 */
	public function getCandidateUser() {
		return $this->hasOne(User::class, ['id' => 'candidate_user_id']);
	}
}
