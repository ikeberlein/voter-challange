<?php

namespace app\controllers;

use Yii;
use app\models\Card;
use app\models\Vote;
use yii\data\ActiveDataProvider;
use yii\filters\auth\HttpBasicAuth;
use yii\filters\auth\HttpBearerAuth;
use yii\filters\auth\QueryParamAuth;

class VotesController extends \yii\rest\Controller {
	const MAX_CANDIDATES_PER_REQUEST = 5;

	public function behaviors() {
		$behaviors = parent::behaviors();
		$behaviors['authenticator']['authMethods'] = [
			HttpBearerAuth::class,
			QueryParamAuth::class,
			HttpBasicAuth::class,
		];
		return $behaviors;
	}

	public function actionIndex() {
		return new ActiveDataProvider([
			'query' => $this->findCandidates(),
			'pagination' => false
		]);
	}

	private function findCandidates() {
		$user = $this->identityUser();

		$candidates = Card::findCandidatesFor($user)
			->limit($this->getCandidatesPerRequest());

		return $candidates;
	}

	private function getCandidatesPerRequest() {
		return \Yii::$app->params['maxCandidatesPerRequest'] ?? self::MAX_CANDIDATES_PER_REQUEST;
	}

	public function actionCreate() {
		$model = $this->makeVoteModel();

		if ($model->save()) {
			$response = Yii::$app->getResponse();
			$response->setStatusCode(201);
		} elseif (!$model->hasErrors()) {
			throw new ServerErrorHttpException(
				'Failed to create the object for unknown reason.'
			);
		}

		return $model;
	}

	private function makeVoteModel() {
		$model = new Vote();

		$model->load(Yii::$app->request->getBodyParams(), '');
		$model->user_id = $this->identityUser()->getId();

		return $model;
	}

	private function identityUser() {
		return \Yii::$app->getUser()->getIdentity();
	}
}
